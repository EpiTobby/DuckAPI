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
                'body': json.dumps(resp['Item'], default=to_serializable)
            }
        except:
            pass
    return {
        'statusCode': 404,
        'body':  json.dumps({})
    }

def to_serializable(val):
    """JSON serializer for objects not serializable by default"""

    if type(val) is decimal.Decimal:
        return int(val)

    return val
