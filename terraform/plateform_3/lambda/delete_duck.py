import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('ducks')
    queryParameters = event['pathParameters']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        table.delete_item(
         Key={
             'uuid': uuid
         }
        )
        return {
            'statusCode': 200,
            'body': json.dumps({})
        }
        
    return {
        'statusCode': 404,
        'body': json.dumps({})
    }
