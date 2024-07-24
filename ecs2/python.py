import boto3
import sys

def take_db_snapshot(DBSnapshotId, DBInstanceId):
    rds = boto3.client('rds',region_name="eu-central-1")
    response = rds.create_db_snapshot(
        DBSnapshotIdentifier=DBSnapshotId,
        DBInstanceIdentifier=DBInstanceId
    )
    print(response)

def update_parameter_store(DBSnapshotId):
    ssm = boto3.client('ssm',region_name="eu-central-1")
    response = ssm.put_parameter(Name='/rds/snapshot/name',Value=DBSnapshotId,Overwrite=True)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 take_ebs_snapshot.py <DBSnapshotId> <DBInstanceId>")
        sys.exit(1)
    
    DBSnapshotId = sys.argv[1]
    DBInstanceId = sys.argv[2]
    
    
    take_db_snapshot(DBSnapshotId, DBInstanceId)
    update_parameter_store(DBSnapshotId)