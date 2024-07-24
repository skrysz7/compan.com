import boto3
import sys
import docker

def take_db_snapshot(DBSnapshotId, DBInstanceId):
    rds = boto3.client('rds',region_name="eu-central-1")
    response = rds.create_db_snapshot(
        DBSnapshotIdentifier=DBSnapshotId,
        DBInstanceIdentifier=DBInstanceId
    )
    print(response)

def update_parameter_store_db(DBSnapshotId):
    ssm = boto3.client('ssm',region_name="eu-central-1")
    response = ssm.put_parameter(Name='/rds/snapshot/name',Value=DBSnapshotId,Overwrite=True)

def update_parameter_store_ecs(cluster_name):
    ecs = boto3.client('ecs',region_name="eu-central-1")
    # List the running tasks in the cluster
    response = ecs.list_tasks(cluster=cluster_name,desiredStatus='RUNNING')
    task_arns = response['taskArns']
    # Check if there are any running tasks
    if not task_arns:
        print("No running tasks found in the cluster.")
    else:
        # Describe the first task to get detailed information
        first_task_arn = task_arns[0]
        response = ecs.describe_tasks(cluster=cluster_name, tasks=[first_task_arn])
        tasks = response['tasks']

        # Extract and print the image information from the first task's container definitions
        first_task = tasks[0]
        for container in first_task['containers']:
            image = container['image']
            print(f"Container Name: {container['name']}, Image: {image}")

    ssm = boto3.client('ssm',region_name="eu-central-1")
    response = ssm.put_parameter(Name='/ecr/image/name',Value=image,Overwrite=True)

def copy_image(container_image_version,container_ecr_url):
    ecr           = boto3.client('ecr',region_name="eu-central-1")
    docker_client = docker.from_env()
    source_image  = f"nginxdemos/hello:{container_image_version}"
    ecr_repository = f"{container_ecr_url}:{container_image_version}"
    docker_client.images.pull(source_image)
    docker_client.images.get(source_image).tag(ecr_repository)
    response = ecr.get_authorization_token()
    auth_data = response['authorizationData'][0]
    username, password = auth_data['authorizationToken'].decode('base64').split(':')
    registry = auth_data['proxyEndpoint']
    docker_client.login(username=username, password=password, registry=registry)
    docker_client.images.push(ecr_repository)

if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: python3 python.py <DBSnapshotId> <DBInstanceId> <cluster_name>" )
        sys.exit(1)
    
    DBInstanceId = sys.argv[1]
    DBSnapshotId = sys.argv[2]
    cluster_name = sys.argv[3]
    container_image_version = sys.argv[4]
    container_ecr_url = sys.argv[5]
    
    
    take_db_snapshot(DBSnapshotId, DBInstanceId)
    update_parameter_store_db(DBSnapshotId)
    update_parameter_store_ecs(cluster_name)
    #copy_image(container_image_version,container_ecr_url)