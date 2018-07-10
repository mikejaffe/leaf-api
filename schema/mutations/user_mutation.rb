module Schema
  module Mutations

    UserInputType = GraphQL::InputObjectType.define do
      name "UserInputType"
      description "Login a user via email and password"
      argument :email, !types.String
      argument :password, types.String
    end

    SignUpInputType = GraphQL::InputObjectType.define do
      name "SignUpInputType"
      description "Registers a new users"
      argument :email, !types.String
      argument :password, !types.String
      argument :password_confirmation, !types.String
      argument :first_name, types.String 
      argument :last_name, types.String
    end

    UserPreferenceInputType = GraphQL::InputObjectType.define do
      name "UserPreferenceInputType"
      argument :metric, types.Boolean
      argument :temperature, types.Boolean
      argument :timelapses, types.Boolean
    end

    UpdateUserInputType = GraphQL::InputObjectType.define do
      name "UpdateUserInputType"
      argument :email, types.String
      argument :first_name, types.String 
      argument :last_name, types.String
      argument :phone, types.String
      argument :temperature, types.Boolean
      argument :timelapses, types.Boolean
      argument :password, types.String
      argument :password_confirmation, types.String 
      argument :preferences, UserPreferenceInputType
    end



    UserMutation = GraphQL::ObjectType.define do

      field :update_user_event, Types::UserEventType do 
        argument :id, !types.Int 
        argument :action, types.String 
        argument :value, types.String 
        argument :hidden, types.Boolean
        argument :read, types.Boolean

        description "Updates a User Event"
        resolve ->(obj, args, ctx) { 
          user_event = UserEvent.find(args[:id])
          if user_event.update_attributes(args.to_h)
            user_event.reload
            user_event
          else
            GraphQL::ExecutionError.new(user_event.errors.full_messages.join(","))
          end
        }
      end

      field :update_device_info, types.String do 
        argument :platform, types.String
        argument :os_version, types.String
        argument :model, types.String
        argument :manufacturer, types.String
        argument :app_version, types.String 
        description "Updates a users device info"
        resolve ->(obj, args, ctx) { 
          device = UserDevice.find_or_initialize_by(user_id: ctx[:current_user].id)
          if device.update_attributes(args.to_h)
            "Device updated"
          else
            GraphQL::ExecutionError.new(device.errors.full_messages.join(","))
          end
        }
      end

      field :signup, Types::UserType do 
        argument :user, SignUpInputType
        resolve ->(obj, args, ctx) { 
          user = User.new(args[:user].to_h)   
          if user.valid?
            user.last_sign_in = Time.now
            user.save
            user
          else 
            GraphQL::ExecutionError.new(user.errors.full_messages.join(","))
          end
        }
      end

      field :login, Types::UserType do 
        argument :user, UserInputType
        resolve ->(obj, args, ctx) { 
          user = User.find_by(email: args[:user][:email])
          if user.blank? || user.authenticate(args[:user][:password]).blank?
            return GraphQL::ExecutionError.new("In-valid email or password")
          else
            user.regenerate_token if user.token.blank?
            user.update_attribute("last_sign_in", Time.now)
            return user
          end
        }
      end

      field :forgot_password, types.String do 
        argument :email, !types.String  
        description "Sends a password reset"
        resolve ->(obj, args, ctx) { 
          @user = User.find_by_email(args[:email])
          if @user
            @user.forgot_password_email
            "Password reset instructions sent." 
          else
            GraphQL::ExecutionError.new("Email does not exist.")
          end
          # @resource = User.find_by_email(args[:email])
          # if @resource
          #   @resource.send_reset_password_instructions
          #   "Password reset instructions sent." 
          # else
          #   GraphQL::ExecutionError.new("Email does not exist.")
          # end
        }
      end

      field :update_user, Types::UserType do 
        argument :user, UpdateUserInputType
        description "Updates a user"
        resolve ->(obj, args, ctx) { 
          user = ctx[:current_user]
          user_args = args[:user].to_h  

          if user.update_attributes(user_args)
            user.reload
          else 
            GraphQL::ExecutionError.new(user.errors.full_messages.join(","))
          end
        }
      end


    end
  end
end