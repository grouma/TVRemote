// This #include statement was automatically added by the Spark IDE.
#include "IRremote.h"

IRsend irsend(D0);


int sendIR(String args){
    // Args contains 3 characters for format
    // and 10 characters for hex value
    if(args.length() == 13){
        String format = args.substring(0,3);
        if(format == "NEC"){
            // Since hexString is prepended with 0x use base 0
            int code = (int) strtol(&(args[3]), NULL, 0);
            irsend.sendNEC(code,32);
            return 1;
        }
    }
    return 0;
}

void setup() {
    Spark.function("sendIR", sendIR);
}

void loop() {

}

