#include <core.p4>

header eth_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

struct internal_t {
    bit<4> val;
}

struct headers_t {
    eth_t  _baseEth0;
    eth_t  _extEth1;
    bit<4> _internal_val2;
}

control ingress(inout headers_t hdr) {
    @name("ingress.c2.outerDst.A") action c2_outerDst_A_0(@name("v") bit<4> v) {
    }
    @name("ingress.c2.outerDst.A") action c2_outerDst_A_1() {
    }
    @name("ingress.c2.outerDst.B") action c2_outerDst_B_0() {
    }
    @name("ingress.c2.outerDst.lookup") table c2_outerDst_lookup {
        key = {
            hdr._baseEth0.dstAddr: exact @name("address");
        }
        actions = {
            c2_outerDst_A_0();
            c2_outerDst_B_0();
        }
        const default_action = c2_outerDst_A_0(4w15);
        size = 65536;
    }
    @name("ingress.c2.outerSrc.A") action c2_outerSrc_A_0(@name("v") bit<4> v_2) {
    }
    @name("ingress.c2.outerSrc.A") action c2_outerSrc_A_1() {
    }
    @name("ingress.c2.outerSrc.B") action c2_outerSrc_B_0() {
    }
    @name("ingress.c2.outerSrc.lookup") table c2_outerSrc_lookup {
        key = {
            hdr._baseEth0.srcAddr: exact @name("address");
        }
        actions = {
            c2_outerSrc_A_0();
            c2_outerSrc_B_0();
        }
        const default_action = c2_outerSrc_A_0(4w15);
        size = 65536;
    }
    @name("ingress.c2.innerDst.A") action c2_innerDst_A_0(@name("v") bit<4> v_4) {
    }
    @name("ingress.c2.innerDst.A") action c2_innerDst_A_1() {
    }
    @name("ingress.c2.innerDst.B") action c2_innerDst_B_0() {
    }
    @name("ingress.c2.innerDst.lookup") table c2_innerDst_lookup {
        key = {
            hdr._extEth1.dstAddr: exact @name("address");
        }
        actions = {
            c2_innerDst_A_0();
            c2_innerDst_B_0();
        }
        const default_action = c2_innerDst_A_0(4w15);
        size = 65536;
    }
    @name("ingress.c2.innerSrc.A") action c2_innerSrc_A_0(@name("v") bit<4> v_6) {
    }
    @name("ingress.c2.innerSrc.A") action c2_innerSrc_A_1() {
    }
    @name("ingress.c2.innerSrc.B") action c2_innerSrc_B_0() {
    }
    @name("ingress.c2.innerSrc.lookup") table c2_innerSrc_lookup {
        key = {
            hdr._extEth1.srcAddr: exact @name("address");
        }
        actions = {
            c2_innerSrc_A_0();
            c2_innerSrc_B_0();
        }
        const default_action = c2_innerSrc_A_0(4w15);
        size = 65536;
    }
    @hidden table tbl_c2_outerDst_A {
        actions = {
            c2_outerDst_A_1();
        }
        const default_action = c2_outerDst_A_1();
    }
    @hidden table tbl_c2_outerSrc_A {
        actions = {
            c2_outerSrc_A_1();
        }
        const default_action = c2_outerSrc_A_1();
    }
    @hidden table tbl_c2_innerDst_A {
        actions = {
            c2_innerDst_A_1();
        }
        const default_action = c2_innerDst_A_1();
    }
    @hidden table tbl_c2_innerSrc_A {
        actions = {
            c2_innerSrc_A_1();
        }
        const default_action = c2_innerSrc_A_1();
    }
    apply {
        if (hdr._baseEth0.isValid()) {
            c2_outerDst_lookup.apply();
        } else {
            tbl_c2_outerDst_A.apply();
        }
        if (hdr._baseEth0.isValid()) {
            c2_outerSrc_lookup.apply();
        } else {
            tbl_c2_outerSrc_A.apply();
        }
        if (hdr._extEth1.isValid()) {
            c2_innerDst_lookup.apply();
        } else {
            tbl_c2_innerDst_A.apply();
        }
        if (hdr._extEth1.isValid()) {
            c2_innerSrc_lookup.apply();
        } else {
            tbl_c2_innerSrc_A.apply();
        }
    }
}

control Ingress<H>(inout H hdr);
package Pipeline<H>(Ingress<H> ingress);
package Switch<H>(Pipeline<H> pipe);
Pipeline<headers_t>(ingress()) ig;
Switch<headers_t>(ig) main;
