/* -*- Mode: C -*- */

#define PERL_NO_GET_CONTEXT 1

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

static IV
bu_first(pTHX_ SV *bv, IV start) {
    STRLEN len;
    const char *bytes = SvPV_const(bv, len);
    char byte;
    IV byte_ix;
    IV bit_ix;

    if (start < 0) start = 0;
    byte_ix = start / 8;
    bit_ix = start & 7;

    while (byte_ix < len) {
        if (byte = bytes[byte_ix]) {
            while (bit_ix < 8) {
                if ((byte >> bit_ix) & 1)
                    return byte * 8 + bit_ix;
                bit_ix++;
            }
        }
        bit_ix = 0;
        byte_ix++;
    }
    return -1;
}

static IV
bu_last(pTHX_ SV *bv, IV end) {
    STRLEN len;
    const char *bytes = SvPV_const(bv, len);
    char byte;
    IV byte_ix;
    IV bit_ix;

    byte_ix = (end < 0 ? len : end / 8);
    if (byte_ix < len)
        bit_ix = end & 7;
    else  {
        byte_ix = len - 1;
        bit_ix = 7;
    }

    while (byte_ix >= 0) {
        if (byte = bytes[byte_ix]) {
            while (bit_ix >= 0) {
                if ((byte >> bit_ix) & 1)
                    return byte * 8 + bit_ix;
                bit_ix--;
            }
        }
        bit_ix = 7;
        byte_ix--;
    }
    return -1;
}

MODULE = Bit::Util		PACKAGE = Bit::Util		

IV
bu_first(bv, start = -1)
    SV *bv
    IV start
CODE:
    RETVAL = bu_first(aTHX_ bv, start);
OUTPUT:
    RETVAL

IV
bu_last(bv, end = -1)
  SV *bv
  IV end
CODE:
    RETVAL = bu_last(aTHX_ bv, end);
OUTPUT:
    RETVAL
  
  

