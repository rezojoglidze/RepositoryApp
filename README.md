# RepositoryApp


Repository database application.

## API Reference

#### Get all user repos 

```http
  GET https://api.github.com/users/${user}/repos{?page,per_page}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `user` | `string` | **Required**. inputed username |

| Query | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `page` | `Int` | **Required**. page number |
| `per_page` | `Int` | **Required**. Number of items per page |

#### Get user repo details
```http
  GET https://api.github.com/repos/${owner}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `owner` | `string` | **Required**. this param can get from the previous service owner object's ownerName|

## Used Technologies

Swift language.

Core Data to store Data Locally.

MVVM+C(Coordinator Design Pattern).

UIKit to create UI.

URLSession for making API requests.



  

## Authors

- [@rezojoglidze](https://github.com/rezojoglidze)

