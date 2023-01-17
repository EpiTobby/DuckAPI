def lambda_handler(event, context):

    return {
        "statusCode": 200,
        "body": "",
        "isBase64Encoded": "false",
        "headers": {
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "GET,PUT,POST,DELETE,OPTIONS,PATCH",
            "Access-Control-Allow-Origin": "*",
        },
    }
