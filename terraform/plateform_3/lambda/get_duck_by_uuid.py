import decimal
import json
import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('ducks')
    
    response = table.scan()
    data = response['Items']

    queryParameters = event['pathParameters']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            data.extend(response['Items'])
        for duck in data:
            if duck['uuid'] == uuid:
                return {
                    'statusCode': 200,
                    'body': json.dumps(duck, default=to_serializable)
                }
    return {
        'statusCode': 404,
        'body': json.dumps({})
    }


def to_serializable(val):
    """JSON serializer for objects not serializable by default"""

    if type(val) is decimal.Decimal:
        return int(val)

    return val