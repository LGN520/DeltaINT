/***********************/
/* Ingress Processing (Normal Operation) */
/***********************/

action nop() {}

// Stage 0

action ipv4_forward(port) {
	modify_field(ig_intr_md_for_tm.ucast_egress_port, port);
	add_to_field(ipv4_hdr.ttl, -1);
}

#ifdef DEBUG
counter ipv4_lpm_counter {
	type: packets_and_bytes;
	direct: ipv4_lpm;
}
#endif

@pragma stage 0
table ipv4_lpm {
	reads {
		udp_hdr.dstPort: exact;
		ipv4_hdr.dstAddr: lpm;
	}
	actions {
		ipv4_forward;
		nop;
	}
	default_action: nop();
	size: 1;
}
