module Schema
  module Mutations
    LeafBoxEventMutation = GraphQL::ObjectType.define do

      field :mark_read, Types::LeafBoxEventType do 
        description "Mark log read by the users"
        argument :id, !types.Int
        resolve ->(obj, args, ctx) {
          event = LeafBoxEvent.find(args[:id])
          event.update_column("read", true)
          event.reload
          return event
        }
      end

      field :mark_read, types.String do 
        description "Mark log read by the users"
        argument :grow_id, !types.Int
        resolve ->(obj, args, ctx) {
          LeafBoxEvent.where(grow_id: args[:grow_id]).update_all(read: true)
          "LeafBox Events updated"
        }
      end

      field :append_event_log, types.String do   
        description "Adds to the leaf_box event log"
        argument :photon_id, !types.String 
        argument :action, !types.String 
        argument :value, !types.String 
        argument :grow_id, types.Int
        resolve ->(obj, args, ctx) {
          begin
            leaf_box = LeafBox.find_by_photon_id(args[:photon_id])
            grow_id = if args[:grow_id]
                          args[:grow_id]
                          elsif leaf_box.current_grow
                            leaf_box.current_grow.id
                          else
                            nil
                          end
                              
            LeafBoxEvent.create(leaf_box_id: leaf_box.id, grow_id: grow_id, action: args[:action], value: args[:value])
            return "Success"
          rescue Exception => e
            return e.message
          end
        }
      end

    end
  end
end