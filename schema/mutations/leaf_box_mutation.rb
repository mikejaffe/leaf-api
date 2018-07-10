module Schema
  module Mutations
    LeafBoxMutation = GraphQL::ObjectType.define do

      field :update_leaf_box, Types::LeafBoxType do 
        description "Updates a Leaf Box"
        argument :id, !types.Int 
        argument :name, types.String 
        argument :time_zone, types.String
        argument :leaf_box_firmware, types.String
        resolve ->(obj, args, ctx) { 
          leaf_box = LeafBox.find(args[:id])
          if leaf_box.update_attributes(args.to_h)
            leaf_box.reload
            leaf_box
          else
            GraphQL::ExecutionError.new(leaf_box.errors.full_messages.join(","))
          end
        }
      end

      field :claim, Types::LeafBoxType do   
        description "Assigns a LeafBox to a User"
        argument :photon_id, !types.String 
        resolve ->(obj, args, ctx) { 
          leaf_box = LeafBox.find_by_photon_id(args[:photon_id])
          leaf_box.claim(ctx[:current_user].id)
          if leaf_box.errors.count == 0
            return leaf_box
          else
            GraphQL::ExecutionError.new(leaf_box.errors.full_messages.join(","))
          end
        }
      end


      field :unclaim, Types::LeafBoxType do   
        description "Unasigns a LeafBox to a User"
        argument :photon_id, !types.String 
        resolve ->(obj, args, ctx) { 
          leaf_box = LeafBox.find_by_photon_id(args[:photon_id])
          if leaf_box.current_grow.nil?
            if leaf_box.update_attribute("owner_id", nil)
              return leaf_box
            else
              GraphQL::ExecutionError.new(leaf_box.errors.full_messages.join(","))
            end
          else
            GraphQL::ExecutionError.new("Leaf box has an active grow")
          end
        }
      end


      field :start_live_stream, types.String do 
        description "Starts a leafbox live video"
        argument :photon_id, !types.String 
        resolve ->(obj, args, ctx) { 
          leaf_box = LeafBox.find_by_photon_id(args[:photon_id])
          Particle.new.init_live_stream(leaf_box.photon_id, leaf_box.owner.particle["access_token"])
          return leaf_box.live_stream_url
        }
      end

      field :time_lapse_video, Types::DelayedJobType do   
        argument :leaf_box_id, !types.Int 
        argument :range_from, !types.String 
        argument :range_to, !types.String 
        argument :fps, types.Int  
        description "Creates a time lapse video for a given range"
        resolve ->(obj, args, ctx) { 
          leaf_box = LeafBox.find(args[:leaf_box_id])
          Time.zone = (leaf_box.time_zone) 
          range = Time.zone.parse("#{args[:range_from]} 00:00:00")..Time.zone.parse("#{args[:range_to]} 23:59:59")
          photos = leaf_box.photos.where(["created_at >= ? and created_at <= ?", range.min, range.max]).count
           
          if photos <= 1
           return GraphQL::ExecutionError.new("LeafBox does not have photos for this date range")
          end
          job_id = nil 
          fps = args[:fps].blank? ? 15 : args[:fps]
          redis = Redis.new(host: ENV["REDIS_ENDPOINT"])
          job_key = "timelapse:#{leaf_box.timelapse_file_name(range.min, range.max, fps )}"
          unless leaf_box.timelapse_video_exists?(range.min, range.max, fps )
            if redis.get(job_key).nil?
              job_id = TimeLapseVideoJob.perform_later(
               leaf_box , 
                  range.min.to_s, 
                  range.max.to_s, 
                  fps).provider_job_id
              redis.set(job_key , job_id)
            else
              job_id = redis.get(job_key)
            end
          else
             redis.del(job_key)
          end
          Struct.new(:job_id, :item).new(job_id, leaf_box.timelapse_video_url(range.min, range.max, fps) )
        }
      end


      field :temp_store, types.String do 
        description "Stores a temporary string for retreival later"
        argument :string, !types.String

        resolve ->(obj, args, ctx) { 
          begin
           items = args[:string].split(",")
           redis = Redis.new(host: ENV["REDIS_ENDPOINT"])
           redis.set(items[0].strip, items)
           return "Success"
          rescue Exception => e
            return e.message
          end
        }
      end


    end
  end
end