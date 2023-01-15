import json
import boto3
import uuid

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('ducks')
    duck = {"uuid": str(uuid.uuid4()),"name": event["name"], "age": event["age"], "color": event["color"].upper()}
    print("Item: " + str(duck))
    table.put_item(Item=duck)
    return {
        'statusCode': 200,
        'body': duck
    }
