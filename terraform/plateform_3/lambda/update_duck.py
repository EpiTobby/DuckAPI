import json
import decimal
import boto3


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('ducks')

    queryParameters = event['params']['querystring']
    if 'uuid' in queryParameters:
        uuid = queryParameters['uuid']
        if 'age' in event["body"]:
            resp = table.update_item(
                 Key={'uuid': uuid},
                 UpdateExpression="SET age= :s",
                 ExpressionAttributeValues={':s': event["body"]["age"]},
                 ReturnValues="UPDATED_NEW"
            )
            print(resp['Attributes'])
        if 'color' in event["body"]:
            resp = table.update_item(
                 Key={'uuid': uuid},
                 UpdateExpression="SET color= :s",
                 ExpressionAttributeValues={':s': event["body"]["color"].upper()},
                 ReturnValues="UPDATED_NEW"
            )
            print(resp['Attributes'])
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
    return {
        'statusCode': 404,
        'body': json.dumps({}),
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
