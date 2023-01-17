import decimal
import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('ducks')
    
    queryParameters = event['params']['querystring']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        try:
            resp = table.get_item(
                Key={
                    'uuid': uuid
                },
            )
            return {
                'statusCode': 200,
                'body': json.dumps(resp['Item'], default=to_serializable),
                "headers": {
                    "Access-Control-Allow-Headers": "*",
                    "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS,PATCH",
                    "Access-Control-Allow-Origin": "*",
                },
            }
        except:
            pass
    return {
        'statusCode': 404,
        'body':  json.dumps({}),
        "headers": {
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS,PATCH",
            "Access-Control-Allow-Origin": "*",
        },
    }

def to_serializable(val):
    """JSON serializer for objects not serializable by default"""

    if type(val) is decimal.Decimal:
        return int(val)

    return val
