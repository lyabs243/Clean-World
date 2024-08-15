# App models

## Settings
_SettingsItem - SettingsProvider - SettingsRepository_

### Item

**Properties**
* lang code (string)
* is dark mode (bool)

**Methods**
* toMap
* fromMap

### Provider - Repository
* getSettings
* setSettings

## User
_UserItem - UserProvider - UserRepository_

### Item

**Properties**
* auth id (string)
* email (string)
* name (string)
* photo url (string)
* is admin (bool)
* created at (DateTime)

**Methods**
* toMap
* fromMap

### Provider - Repository
* add
* update
* delete
* get 
* get from email

## Place
_PlaceItem - PlaceProvider - PlaceRepository_

### Item

**Properties**
* description (string)
* latitude (double)
* longitude (double)
* position (GeoPoint)
* photo urls (List<String>)
* city (string)
* created by (string)
* created at (DateTime)

**Methods**
* toMap
* fromMap

### Provider - Repository
* add
* update
* delete
* get
* get places
* get nearby places

## News
_NewsItem - NewsProvider - NewsRepository_

### Item

**Properties**
* title (string)
* description (string)
* photo url (string)
* created at (DateTime)
* created by (string)
* date (DateTime)
* status (NewsStatus | pending, published) (enum)

**Methods**
* toMap
* fromMap

### Provider - Repository
* add
* update
* delete
* get
* get news