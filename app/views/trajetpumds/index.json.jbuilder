json.array!(@trajetpumds) do |trajetpumd|
  json.extract! trajetpumd, :id, :driver_id, :shop_id, :td_date, :td_time, :regulier, :drive1_ref, :drive2_ref, :drive3_ref, :drive4_ref, :drive5_ref, :drive6_ref, :drive1_size, :drive2_size, :drive3_size, :drive4_size, :drive5_size, :drive6_size
  json.url trajetpumd_url(trajetpumd, format: :json)
end
