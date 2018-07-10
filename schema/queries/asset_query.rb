module Schema
  Queries::AssetQuery = GraphQL::ObjectType.define do
    
    field :pi_video_stream, types.String  do
      description "Returns Rasberry PI FFMPEG commands"
      argument :photon_id, types.String
      resolve ->(obj, args, ctx) {
        "raspivid -n -w 256 -h 133 -fps 20 -t 0 -b 1800000 -o - | ffmpeg -y -f h264 -i - -c:v copy -map 0:0 -f flv -rtmp_buffer 100 -rtmp_live live rtmp://54.152.203.61/live/#{args[:photon_id]}"
      }
    end
  end
 

  
end

