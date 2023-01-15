import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('ducks')
    
    response = table.scan()
    data = response['Items']
    
    queryParameters = event['params']['querystring']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            data.extend(response['Items'])
        for duck in data:
            if duck['uuid'] == uuid:
                return {
                    'statusCode': 200,
                    'body': duck
                }
    return {
        'statusCode': 404,
        'body': {}
    }
