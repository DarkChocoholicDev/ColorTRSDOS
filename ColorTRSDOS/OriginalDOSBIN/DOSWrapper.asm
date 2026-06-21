       ORG   $0EA4

        ; Runtime $0EA4-$1BCF, emitted first
        INCLUDEBIN "bin\ColorTRSDOS.RAW",$051B,$0D2C

        ; Runtime $0989-$0EA4 inclusive, emitted second
        INCLUDEBIN "bin\ColorTRSDOS.RAW",$0000,$051C

        END   $10A2