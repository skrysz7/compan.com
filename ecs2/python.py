# take_ebs_snapshot.py

import boto3
import sys

# def init_client(account_id, region):
#     ec2_client = boto3.client(
#         'ec2',        
#         region_name=region,
#     )

def take_snapshot(volume_id, snapshot_description):
    ec2 = boto3.client('ec2',region_name="eu-central-1")
    response = ec2.create_snapshot(
        VolumeId=volume_id,
        Description=snapshot_description
    )
    print(response)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 take_ebs_snapshot.py <volume_id> <snapshot_description>")
        sys.exit(1)
    
    volume_id = sys.argv[1]
    snapshot_description = sys.argv[2]
    
    take_snapshot(volume_id, snapshot_description)
