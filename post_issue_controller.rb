def post_issue
  url = ENV.fetch("SLACK_ISSUE_HOOK_URL", nil)

  # Post the issue circuit data
  issue_circuit_data = IssueCircuitDatum.new

  # Parse existing circuit data (assuming it's JSON)
  circuit_data = JSON.parse(params[:circuit_data])


  # Add simulator version to circuit data
  circuit_data["simulatorVersion"] = "latest"

  # Combine with potentially existing data
  issue_circuit_data.data = circuit_data.to_json

  issue_circuit_data.save!

  issue_circuit_data_id = issue_circuit_data.id

  # Send it over to slack hook
  circuit_data_url = "#{request.base_url}/simulator/issue_circuit_data/#{issue_circuit_data_id}"
  text = "#{params[:text]}\nCircuit Data: #{circuit_data_url}"
  HTTP.post(url, json: { text: text }) if Flipper.enabled?(:slack_issue_notification)
  head :ok, content_type: "text/html"
end
