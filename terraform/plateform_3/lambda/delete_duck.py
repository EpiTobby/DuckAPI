import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('ducks')
    queryParameters = event['params']['querystring']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        response = table.scan()
        data = response['Items']
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            data.extend(response['Items'])
        for duck in data:
            if duck['uuid'] == uuid:
                resp = table.delete_item(
                 Key={
                     'uuid': uuid,
                     'name': duck['name']
                 }
                )
                return {
                    'statusCode': 200,
                    'body': {}
                }
        
    return {
        'statusCode': 404,
        'body': {}
    }
