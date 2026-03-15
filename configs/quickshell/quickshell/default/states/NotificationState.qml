pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property ListModel transientNotifications: transientNotificationsModel
    readonly property ListModel persistentNotifications: persistentNotificationsModel

    ListModel {
        id: transientNotificationsModel

        property bool shouldRunCleanuTimer: {
            for (let i = 0; i < transientNotificationsModel.count; i++) {
                if (transientNotificationsModel.get(i).expireAtMs !== Infinity) {
                    return true;
                }
            }
            return false;
        }

        function __onNotificationReceived(notification) {
            for (let i = 0; i < transientNotificationsModel.count; i++) {
                if (transientNotificationsModel.get(i).id === notification.id) {
                    transientNotificationsModel.set(i, notification);
                    return;
                }
            }
            transientNotificationsModel.insert(0, notification);
        }

        function __onNotificationRemoved(notificationId) {
            for (let i = 0; i < transientNotificationsModel.count; i++) {
                if (transientNotificationsModel.get(i).id === notificationId) {
                    transientNotificationsModel.remove(i);
                    return;
                }
            }
        }

        function __onHideNotificationRequested(notificationId) {
            transientNotificationsModel.__onNotificationRemoved(notificationId);
        }

        function __onCleanupExpiredNotifications() {
            const now = Date.now();
            for (let i = transientNotificationsModel.count - 1; i >= 0; i--) {
                if (transientNotificationsModel.get(i).expireAtMs <= now) {
                    transientNotificationsModel.remove(i);
                }
            }
        }
    }

    Timer {
        id: transientNotificationCleanupTimer
        interval: 1000
        repeat: true
        running: transientNotificationsModel.shouldRunCleanuTimer
        onTriggered: transientNotificationsModel.__onCleanupExpiredNotifications()
    }

    ListModel {
        id: persistentNotificationsModel

        function __onNotificationReceived(notification) {
            if (notification.transient) {
                return;
            }

            for (let i = 0; i < persistentNotificationsModel.count; i++) {
                if (persistentNotificationsModel.get(i).id === notification.id) {
                    persistentNotificationsModel.set(i, notification);
                    return;
                }
            }
            persistentNotificationsModel.insert(0, notification);
        }

        function __onNotificationRemoved(notificationId) {
            for (let i = 0; i < persistentNotificationsModel.count; i++) {
                if (persistentNotificationsModel.get(i).id === notificationId) {
                    persistentNotificationsModel.remove(i);
                    return;
                }
            }
        }
    }

    NotificationServer {
        id: notificationServer

        imageSupported: true
        bodyHyperlinksSupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        persistenceSupported: true

        onNotification: function (n) {
            n.tracked = true;
            n.closed.connect(() => {
                transientNotificationsModel.__onNotificationRemoved(n.id);
                persistentNotificationsModel.__onNotificationRemoved(n.id);
            });

            const dto = root.__toDto(n, Date.now());
            transientNotificationsModel.__onNotificationReceived(dto);
            persistentNotificationsModel.__onNotificationReceived(dto);
        }
    }

    function invokeAction(notificationId, actionIdentifier) {
        const notifications = notificationServer.trackedNotifications.values;
        const notification = notifications.find(n => n.id === notificationId);
        if (notification === undefined) {
            console.warn(`Notification with ID ${notificationId} not found.`);
            return;
        }

        const action = notification.actions.find(a => a.identifier === actionIdentifier);
        if (action === undefined) {
            console.warn(`Action with identifier ${actionIdentifier} not found in notification ${notificationId}.`);
            return;
        }

        action.invoke();
    }

    function hideNotification(notificationId) {
        transientNotificationsModel.__onHideNotificationRequested(notificationId);
    }

    function dismissNotification(notificationId) {
        const notifications = notificationServer.trackedNotifications.values;
        const notification = notifications.find(n => n.id === notificationId);
        if (notification === undefined) {
            console.warn(`Notification with ID ${notificationId} not found.`);
            return;
        }

        notification.dismiss();
    }

    function clearAllNotifications() {
        const notifications = notificationServer.trackedNotifications.values;
        for (let i = notifications.length - 1; i >= 0; i--) {
            notifications[i].dismiss();
        }
    }

    function __toActionDto(n, a) {
        return {
            valid: true,
            notificationId: n.id,
            identifier: a.identifier,
            text: a.text
        };
    }

    function __toDto(n, sentAtMs) {
        const TIMEOUT_MS = 5000;
        const expireAtMs = n.urgency === NotificationUrgency.Critical ? Infinity : sentAtMs + TIMEOUT_MS;

        const rawDefaultAction = n.actions.filter(a => a.identifier === "default")[0];
        const defaultAction = rawDefaultAction ? root.__toActionDto(n, rawDefaultAction) : {};

        return {
            id: n.id,
            appIcon: n.appIcon,
            appName: n.appName,
            summary: n.summary,
            body: n.body,
            urgency: NotificationUrgency.toString(n.urgency),
            expireAtMs: expireAtMs,
            resident: n.resident,
            actions: n.actions.filter(a => a.identifier !== "default").map(a => root.__toActionDto(n, a)),
            defaultAction: defaultAction
        };
    }
}
