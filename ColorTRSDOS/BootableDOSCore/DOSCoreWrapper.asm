       ORG   $0EA4

        ; Runtime $0EA4-$1BCF, emitted first
        INCLUDEBIN "bin\DOSCore.RAW",$051B

        ; Runtime $0989-$0EA4 inclusive, emitted second
        INCLUDEBIN "bin\DOSCore.RAW",$0000,$051C

        END     $10A2