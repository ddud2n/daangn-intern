# Daangn_intern

## 2021 당근마켓 서버 개발 인턴 과제

### 환경설정
- ruby -v :  2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]
- rails -v : Rails 6.0.3.2
- redis-server --version : Redis server v=4.0.0 




### 실행방법
📌 redis-server를 설치하고 실행시켜주세요. 127.0.0.1:6379 <br>
(혹시나, 다른 서버의 redis랑 연결해야한다면 daangn_intern\config\application.yml에서 REDIS_HOST를 바꿔주세요. port는 daangn_intern\config\initializers\redis.rb에서 수정해주세요.)<br><br>
📌 터미널에 다음 명령어를 입력해서 sidekiq 프로세스 및 콘솔을 킵니다.
```
$ sidekiq
```
📌 rails 서버를 실행시킵니다.
```
$ rails s -b 0.0.0.0 -p 3000
```
<br><br>

### 구름IDE에서 실행하기

- 워크스페이스 공유주소 : <a href = "https://goor.me/9RQDC">이동하기</a>
- 터미널 공유주소 : <a href = "https://goor.me/i7g1R">이동하기</a>

- 워크스페이스 공유주소로 이동하여 '당근'으로 들어와 주세요.

![image](https://user-images.githubusercontent.com/37402084/130653819-d8dde703-4696-4bc9-9dcd-3cb919eb5cd8.png)

- 워크스페이스 접속시 다음과 같은 화면이 실행됩니다.

![image](https://user-images.githubusercontent.com/37402084/130654155-49eac00c-f893-456d-b553-888789b253fe.png)

⭐ 주의사항 : 혹시 프로젝트 폴더 로딩이 오래 걸린다면, 왼쪽 프로젝트 메뉴에서 "새로고침" 버튼을 눌러주세요.

- 터미널에서 redis-server를 실행합니다.

![image](https://user-images.githubusercontent.com/37402084/130654486-2bd571f4-22b1-4572-9c31-84ff5ad38b11.png)

```
$ redis-server /etc/redis/redis.conf
```

- sidekiq를 실행합니다.

![image](https://user-images.githubusercontent.com/37402084/130654720-217a6620-1830-42b1-ae7e-cf8936fa5d72.png)


- rails를 실행합니다. (new run ruby on rails 메뉴클릭)

![image](https://user-images.githubusercontent.com/37402084/130654963-deaf833b-bd76-4160-815e-c434b88bcec5.png)

![image](https://user-images.githubusercontent.com/37402084/130655671-99e8d65a-e9b1-4721-aa2e-6d9d23855ce8.png)


- https://daangn-intern-mphyq.run.goorm.io/ 이 주소로 접속하면 rails가 잘 실행이 되는 것을 확인할 수 있습니다.





<br><br>

### 과제 구현방식 설명

#### 1.중고거래 게시글 작성 api

- scaffold로 post CRUD를 구현하였습니다.
- pusher gem 과 jquery를 통해 또다른 게시글 페이지에서도 실시간으로 게시글이 올라오는 것을 확인할 수 있습니다.
- view page : https://daangn-intern-mphyq.run.goorm.io/posts
- api : [POST] https://daangn-intern-mphyq.run.goorm.io/posts
```
{
  "username" : "lee",
   "title" : "아이패드 프로 16인치",
   "description" : "싸게 내놓아요~"
}
```

![image](https://user-images.githubusercontent.com/37402084/130658836-41fe9374-c37d-4402-8e85-ce695f5ccbbc.png)


<br>

#### 2. 알람키워드 등록 삭제 api

- scaffold로 keyword CRUD를 구현하였습니다.
- pusher gem 과 jquery를 통해 통해 또다른 키워드 페이지에서도 실시간으로 키워드가 올라오는 것을 확인할 수 있습니다.
- view page : https://daangn-intern-mphyq.run.goorm.io/keywords
- 삭제 api : [DELETE] http://daangn-intern-mphyq.run.goorm.io/keywords/{:keywordId}
- 등록 api : [POST] https://daangn-intern-mphyq.run.goorm.io/keywords
```
{
  "username" : "lee",
   "word" : "애플펜슬"
}
```

![image](https://user-images.githubusercontent.com/37402084/130658910-8b41fe44-dbe5-4eec-b3cf-109be21aec84.png)

<br>

#### 3. 키워드 알림 발송

- scaffold로 alarm CRUD를 구현하였습니다.
- pusher gem 과 jquery를 통해 또다른 알림 페이지 혹은 유저페이지 에서도 실시간으로 알림이 올라오는 것을 확인할 수 있습니다.
- post(중고게시글)이 Create되면, 게시글의 키워드를 기반으로 대상을 뽑고 알림을 create 합니다.
- 이때, sidekiq을 통해 비동기로 동작하게 됩니다.
- view page : https://daangn-intern-mphyq.run.goorm.io/alarms
- User view page : https://daangn-intern-mphyq.run.goorm.io/user/{:username}
- 현재 등록된 유저의 username는 sujin, lee, 이수진 3명이라 가정한 상황입니다.(이때, username은 unique하다 가정하였습니다.)
- ⭐키워드를 기반으로 대상을 뽑는 알고리즘은 daangn_intern\app\controllers\posts_controller.rb 의 create 함수에서 구현하였습니다.


![image](https://user-images.githubusercontent.com/37402084/130658953-1a5274ce-2cbc-4535-911b-fb3b0df152e1.png)


![image](https://user-images.githubusercontent.com/37402084/130659074-fd13736b-da3e-4489-bb3c-6d77478e7aba.png)



<br><br>
