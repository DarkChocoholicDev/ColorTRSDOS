        ORG      $2600

        ; "Bootable" signature.
        FCC      "OS"

        ; Relocate the core DOS code.


        ; Include our core DOS code.
DOSCore:
        INCLUDEBIN "bin\DOSCore.raw"

        END
