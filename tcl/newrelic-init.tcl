# Register filters to handle newrelic reporting
#set LICENSE_KEY "0f81d1f3735c53779fbef5143e1975d160bd7227"
#set APP_NAME "csmdev"

#ad_register_filter preauth * /* newrelic_preauth_filter
#ad_register_filter -critical t -priority 999999 trace * /* newrelic_trace_filter
