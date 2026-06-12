---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375575998127000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375575998128000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375575998129000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375575998130000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375575998131000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 14:55:59 CET 2026 by abi7287
