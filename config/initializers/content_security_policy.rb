# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |p|
  p.default_src :self, :https
  p.font_src    :self, :https, :data
  p.img_src     :self, :https, :data
  p.object_src  :none
  if Rails.env.development? || Rails.env.test?
    p.connect_src :self, :https, 'ws://localhost:3035', 'http://localhost:3035'
    p.script_src :self, :https, :unsafe_eval
  else
    p.script_src :self, :https
  end
  p.style_src :self, :https, :unsafe_inline

  # Specify URI for violation reports
  # p.report_uri "/csp-violation-report-endpoint"
end

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
