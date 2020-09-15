{ config, lib, pkgs, ... }:

{
    services.hadoop = {
        package = pkgs.hadoop_3_1;
        hdfs.datanode.enabled = true;
        hdfs.namenode.enabled = true;
        coreSite = {
            "fs.defaultFS" = "hdfs://127.0.0.1:9000";    
        };

        # remember to create /var/lib/hdfs and chown to hdfs
        hdfsSite = {
            "dfs.replication" = 1;
            "dfs.namenode.name.dir" = "file:///var/lib/hdfs/name";
            "dfs.datanode.data.dir" = "file:///var/lib/hdfs/data";
        };
    };
    services.hbase = {
        enable = true;
    };
}
