$TestsPath = Split-Path $MyInvocation.MyCommand.Path

#$FunctionsPath = join-Path -Path (get-item $TestsPath).Parent -ChildPath "Functions"

$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName

set-location -Path $RootFolder.FullName

Write-Verbose "Importing module"

import-module .\PSHTML -Force

Context "Testing PSHTML"{
    Describe "Testing span" {


        $Class = "MyClass"
        $Id = "MyID"
        $Style = "Background:green"
        $CustomAtt = @{"MyAttribute1"='MyValue1';"MyAttribute2"="MyValue2"}
        $string = span -content {"woop"} -Attributes $CustomAtt -Style $Style -Class $class -id $id

        if($string -is [array]){
            $string = $String -join ""
        }

        it "Should contain opening and closing tags" {
            $string -match '^<span.*>' | should be $true
            $string -match '.*</span>$' | should be $true

        }

        it "Testing content in child element"{
            $string -match "^.*>woop<.*" | should be $true
        }

        it "Testing common parameters: Class"{
            $string -match '^<span.*class="myclass".*>' | should be $true
        }
        it "Testing common parameters: ID"{
            $string -match '^<span.*id="myid".*>' | should be $true
        }
        it "Testing common parameters: Style"{
            $string -match '^<span.*style=".+".*>' | should be $true
        }

        it "Testing Attributes parameters"{

            foreach($at in $CustomAtt.Keys){
                $val = $null
                $val = $CustomAtt[$at]
                $string -match "^<span.*$at=`"$val`".*>" | should be $true
            }


        }

        It 'Should expand variables' {
            #Test for bug https://github.com/Stephanevg/PSHTML/issues/234
            $e = 3
            $res = span -content {$e}

            $res -Match "^<span >3</span>"
        }


    }

}

Pop-Location