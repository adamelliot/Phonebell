#! /usr/bin/env python3

from concurrent.futures import TimeoutError
from google.cloud import pubsub_v1
import json
import subprocess

project_id = "phonebell-336701"
subscription_id = "doorbell-sub"
# Number of seconds the subscriber should listen for messages
timeout = 5.0

subscriber = pubsub_v1.SubscriberClient()
# The `subscription_path` method creates a fully qualified identifier
# in the form `projects/{project_id}/subscriptions/{subscription_id}`
subscription_path = subscriber.subscription_path(project_id, subscription_id)

def callback(message: pubsub_v1.subscriber.message.Message) -> None:
    data = json.loads(message.data)
    events = data['resourceUpdate']['events']

    if 'sdm.devices.events.DoorbellChime.Chime' in events:
        print("Ding...")
        rc = subprocess.call("./ring.sh")
        print("Dong!")
    else:
        print(events)

    message.ack()

streaming_pull_future = subscriber.subscribe(subscription_path, callback=callback)
print(f"Listening for messages on {subscription_path}..\n")

# Wrap subscriber in a 'with' block to automatically call close() when done.
with subscriber:
    try:
        # When `timeout` is not set, result() will block indefinitely,
        # unless an exception is encountered first.
        # streaming_pull_future.result(timeout=timeout)
        streaming_pull_future.result()
    except TimeoutError:
        streaming_pull_future.cancel()  # Trigger the shutdown.
        streaming_pull_future.result()  # Block until the shutdown is complete.