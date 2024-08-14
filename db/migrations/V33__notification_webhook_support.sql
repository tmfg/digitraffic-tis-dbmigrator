-- # Notification Webhook support allows for "pushing" events to external resource servers to trigger behavior
ALTER TABLE company
    ADD COLUMN notification_webhook_uri TEXT;
