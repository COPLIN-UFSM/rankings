class LocalAppsRouter:
    """
    Routes specific apps to the local SQLite database.
    """
    route_app_labels = {
        'auth', 'contenttypes', 'sessions', 'admin',
        'flatpages', 'redirects', 'sites', 'comments'
    }

    def db_for_read(self, model, **hints):
        if model._meta.app_label in self.route_app_labels:
            return 'local_sqlite'
        return 'default'

    def db_for_write(self, model, **hints):
        if model._meta.app_label in self.route_app_labels:
            return 'local_sqlite'
        return 'default'

    def allow_relation(self, obj1, obj2, **hints):
        db_set = {obj1._state.db, obj2._state.db}
        # Prevent relations between different DBs
        if 'local_sqlite' in db_set and 'default' in db_set:
            return False
        return True

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if app_label in self.route_app_labels:
            return db == 'local_sqlite'
        return db == 'default'
