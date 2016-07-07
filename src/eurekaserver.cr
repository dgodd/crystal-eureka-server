require "kemal"
require "json"

serve_static false

before_all do |env|
  puts "Setting response content type"
  env.response.content_type = env.request.headers["content_type"] || "application/json"
end

apps = {} of String => Hash(String, Hash(String, AllParamTypes))

post "/eureka/v2/apps/:appID" do |env|
  appID = env.params.url["appID"]
  apps[appID] ||= {} of String => Hash(String, AllParamTypes)
  apps[appID][env.params.json["hostName"].as(String)] = env.params.json
  env.response.status_code = 204
  nil
end
delete "/eureka/v2/apps/:appID/:instanceID" do |env|
  env.response.status_code = 200
  nil
end
put "/eureka/v2/apps/:appID/:instanceID" do |env|
  env.response.status_code = 200
  # 404 if instanceID doesn’t exist
  nil
end
get "/eureka/v2/apps" do |env|
  apps
end
get "/eureka/v2/apps/:appID" do |env|
  appID = env.params.url["appID"]
  apps[appID].values
end
get "/eureka/v2/apps/:appID/:instanceID" do |env|
  appID = env.params.url["appID"]
  instanceID = env.params.url["instanceID"]
  apps[appID][instanceID]
end

get "/" do |env|
  env.response.content_type = "text/plain"
  "Eureka -- see https://github.com/Netflix/eureka/wiki/Eureka-REST-operations"
end

Kemal.run
