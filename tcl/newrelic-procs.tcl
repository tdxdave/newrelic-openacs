ad_library {
    New Relic Transaction Reporting
}

ad_proc newrelic_preauth_filter {conn args why} {
    Start New Relic Reporting
} {
    global __n
    global __s
#ns_log notice "Before Begin"
    set __n [newrelic_transaction_begin]
#ns_log notice "Before Set Url"
    newrelic_transaction_set_request_url $__n [ns_conn url]
#ns_log notice "Before Segment Begin"
    set __s [newrelic_segment_generic_begin $__n 0 "page_load"]
#ns_log notice "After Segment Begin"
#    ns_log notice "Preauth Filter Done"
    return filter_ok
}

ad_proc newrelic_trace_filter {conn args why} {
    Finish New Relic Reporting
} {
    global __n
    global __s
    # get subsite name
    # get page name
    # TODO figure out why ad_conn isn't working. too early??
    if {[info exists __n]} {
#ns_log notice "Trace: Before Set Name"
	set instance_name [ad_conn instance_name]
	set page_info [join [ad_conn urlv] "."]
	set package_key [ad_conn package_key]
	set transaction_name [string map {" " "_"} "${package_key}:${instance_name}:${page_info}"]
	newrelic_transaction_set_name $__n $transaction_name
ns_log notice "
Transaction Name '${transaction_name}'"

#ns_log notice "Trace: Before Segment End"
	newrelic_segment_end $__n $__s
#ns_log notice "Trace: Before Transaction End"
	newrelic_transaction_end $__n
#ns_log notice "Trace:DONE"
#	ns_log notice "Trace filter ran without preauth filter, maybe resources?"
    } else {
#	ns_log notice "Trace filter ran after preauth filter"
    }
    return filter_ok
}

# TODO Can we track database time unobstrusively?

# Possibly we need to hack developer support?
