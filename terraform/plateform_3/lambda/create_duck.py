import json
import boto3
import uuid

def lambda_handler(event, context):
    print(event)
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('ducks')
    body = json.loads(event["body"])
    duck = {"uuid": str(uuid.uuid4()),"name": body["name"], "age": body["age"], "color": body["color"].upper()}
    print("Item: " + str(duck))
    table.put_item(Item=duck)
    return {
        'statusCode': 200,
        'body': json.dumps(duck)
    }
