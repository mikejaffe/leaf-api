module Schema
  module Mutations
    GrowMutation = GraphQL::ObjectType.define do

      field :create_grow, Types::GrowType do 
        argument :leaf_box_id, !types.Int 
        argument :recipe_id, !types.Int 
        argument :active, types.Boolean 
        description "Creates a grow"
        resolve ->(obj, args, ctx) { 
          grow = Grow.new(args.to_h)
          grow.user = ctx[:current_user]
          grow.started_at = DateTime.now if args[:active]
          grow.current_stage = grow.recipe.stages["grow_stages"].first["symbol"] 
          if grow.valid?
            grow.save
            grow 
          else
            GraphQL::ExecutionError.new(grow.errors.full_messages.join(","))
          end
        }
      end

      field :update_grow, Types::GrowType do 
        argument :id, !types.Int
        argument :recipe_id, types.Int 
        argument :active, types.Boolean 
        description "Updates a grow"
        resolve ->(obj, args, ctx) { 
          grow = Grow.find(args[:id]) 
          update_args = args.to_h 
          update_args.merge!(ended_at: Time.zone.now) if !args[:active] && grow.ended_at.blank?
          if grow.update_attributes(update_args)
            grow.reload
            grow
          else
            GraphQL::ExecutionError.new(grow.errors.full_messages.join(","))
          end
        }
      end


      field :create_grow_log, Types::GrowLogType do 
        argument :leaf_box_id , !types.Int
        argument :grow_id, !types.Int
        argument :ph, types.Float 
        argument :ec, types.Float
        argument :water_temp, types.Float
        argument :air_temp, types.Float
        argument :humidity, types.Float
        argument :light_state, types.Boolean
        argument :light_level, types.Float 
        argument :plant_height, types.Float
        argument :leaf_time, types.String 
        description "Creates a grow log"
        resolve ->(obj, args, ctx) { 
          grow_log = GrowLog.new(args.to_h)
          if grow_log.valid?
            grow_log.save
            grow_log 
          else
            GraphQL::ExecutionError.new(grow.errors.full_messages.join(","))
          end
        }
      end

    end
  end
end