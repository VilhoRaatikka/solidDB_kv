Attached are simple solidDB procedures that emulate the Redis interface. By default, they use the KV_STORE in-memory table, which writes persistent logs and checkpoints.

In addition, solidDB can be used as a conventional relational database. 
The KV_STORE table can be configured to run completely disk-less, or—after a minor tweak to the procedure—as a fully disk-based table. 
The server can be joined at any time either to a HotStandby cluster or to a CRep replication topology.

It’s also possible to create KV_STORE as either a partitioned or a sharded table within a solidDB Grid, provided the Grid has been set up first.
