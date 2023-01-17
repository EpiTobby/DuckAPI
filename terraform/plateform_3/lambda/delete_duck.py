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
            'body': json.dumps({}),
            "headers": {
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS,PATCH",
                "Access-Control-Allow-Origin": "*",
            },
        }
        
    return {
        'statusCode': 404,
        'body': json.dumps({}),
        "headers": {
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS,PATCH",
            "Access-Control-Allow-Origin": "*",
        },
    }
