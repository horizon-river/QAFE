# DB 생성
DROP DATABASE IF EXISTS QAFE;
CREATE DATABASE QAFE;
USE QAFE;

# 게시물 테이블 생성
CREATE TABLE article(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    title CHAR(100) NOT NULL,
    `body` CHAR(100) NOT NULL
);

# 게시물 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

# 회원 테이블 생성
CREATE TABLE `member`(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    loginId CHAR(20) NOT NULL,
    loginPw CHAR(60) NOT NULL,
    `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반, 7=관리자)',
    `name` CHAR(20) NOT NULL,
    nickname CHAR(20) NOT NULL,
    cellphoneNum CHAR(20) NOT NULL,
    email CHAR(50) NOT NULL,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴여부 (0=탈퇴 전,1=탈퇴 후)',
    delDate DATETIME COMMENT '탈퇴날짜'
);

# 회원 테스트 데이터 생성 (관리자)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자',
cellphoneNum = '01012345678',
email = 'kimpk0416@gmail.com';

# 회원 테스트 데이터 생성 (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`authLevel` = 3,
`name` = '사용자1',
nickname = '사용자1',
cellphoneNum = '01098765432',
email = 'kimpk041@gmail.com';

# 회원 테스트 데이터 생성 (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`authLevel` = 3,
`name` = '사용자2',
nickname = '사용자2',
cellphoneNum = '01012341234',
email = 'kimpk04@gmail.com';

# 게시물 테이블에 회원번호 칼럼 추가
ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER `updateDate`;

UPDATE article SET memberId = 2 WHERE memberId = 0;

# 게시판 테이블 생성
CREATE TABLE board(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항), question(Q&A),..',
    `name` CHAR(50) NOT NULL UNIQUE COMMENT '게시판 이름',
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제여부 (0=삭제 전,1=삭제 후)',
    delDate DATETIME COMMENT '삭제날짜'
);

# 기본 게시판 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'notice',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'question',
`name` = 'Q&A';

# 게시물 테이블에 boardId 추가
ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER `memberId`;

# 1 번 게시물을 공지사항 게시물로 수정
UPDATE article
SET boardId = 1
WHERE id IN (1);

# 2,3 번 게시물을 질문 게시물로 수정
UPDATE article
SET boardId = 2
WHERE id IN (2,3);

# 게시물 테이블에 hitCount 추가
ALTER TABLE article ADD COLUMN hitCount INT(10) UNSIGNED NOT NULL DEFAULT 0;

# reactionPoint 테이블
CREATE TABLE reactionPoint(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) UNSIGNED NOT NULL COMMENT '관련 데이터 번호',
    `point` SMALLINT(2) NOT NULL
);

# reactionPoint 테스트 데이터
# 1번 회원이 1번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 article 에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 article 에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

# 게시물 테이블에 goodReactionPoint 칼럼 추가
ALTER TABLE article ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 게시물 테이블에 badReactionPoint 칼럼 추가
ALTER TABLE article ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 기존 게시물의 goodReactionPoint, badReactionPoint 필드 값 채워주기
UPDATE article AS A
INNER JOIN (
    SELECT RP.relTypeCode, RP.relId,
    SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON A.id = RP_SUM.relId
SET A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;

# 댓글 테이블
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(30) NOT NULL COMMENT '관련데이터타입코드',
    relId INT(10) UNSIGNED NOT NULL COMMENT '관련데이터번호',
    `body` TEXT NOT NULL
);

# reply 테스트 데이터
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`body` = '댓글1';

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`body` = '댓글2';

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`body` = '댓글3';

INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 3,
`body` = '댓글4';

# 댓글 테이블에 goodReactionPoint 칼럼 추가
ALTER TABLE reply ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 댓글 테이블에 badReactionPoint 칼럼 추가
ALTER TABLE reply ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 댓글 테이블에 인덱스 걸기
ALTER TABLE `SB_AM`.`reply` ADD INDEX (`relTypeCode` , `relId`);

# 부가정보테이블
CREATE TABLE attr (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `relTypeCode` CHAR(20) NOT NULL,
    `relId` INT(10) UNSIGNED NOT NULL,
    `typeCode` CHAR(30) NOT NULL,
    `type2Code` CHAR(70) NOT NULL,
    `value` TEXT NOT NULL
);

# attr 유니크 인덱스 걸기
## 중복변수 생성금지
## 변수찾는 속도 최적화
ALTER TABLE `attr` ADD UNIQUE INDEX (`relTypeCode`, `relId`, `typeCode`, `type2Code`);

## 특정 조건을 만족하는 회원 또는 게시물(기타 데이터)를 빠르게 찾기 위해서
ALTER TABLE `attr` ADD INDEX (`relTypeCode`, `typeCode`, `type2Code`);

# attr에 만료날짜 추가
ALTER TABLE `attr` ADD COLUMN `expireDate` DATETIME NULL AFTER `value`;

# 회원 테이블의 로그인 비밀번호의 길이를 100으로 늘림
ALTER TABLE `member` MODIFY COLUMN loginPw VARCHAR(100) NOT NULL;

# 기존 회원의 비밀번호를 암호화 
UPDATE `member`
SET loginPw = SHA2(loginPw, 256);

# 게시물 테이블의 내용을 text 타입으로 변경
ALTER TABLE article MODIFY COLUMN `body` TEXT NOT NULL;

# 답변 테이블
CREATE TABLE answer (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(30) NOT NULL COMMENT '관련데이터타입코드',
    relId INT(10) UNSIGNED NOT NULL COMMENT '관련데이터번호',
    `body` TEXT NOT NULL,
    goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0,
    badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0
);

# answer 테스트 데이터
INSERT INTO answer
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 3,
`body` = '답변 테스트1';

INSERT INTO answer
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 3,
`body` = '답변 테스트2';

INSERT INTO answer
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 2,
`body` = '답변 테스트3';

# 답변 테이블에 채택여부를 추가
ALTER TABLE answer ADD COLUMN choiceStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '채택여부 (0=채택안됨,1=채택됨)' AFTER `body`;

# 게시물 테스트 데이터 작성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
boardId = 2,
title = 'Bootstrap 5 드롭다운 메뉴가 작동이 안됩니다. 왜 안되는지 잘 모르겠어요..',
`body` = '코드는 밑에 기록해뒀습니다. 아직 main.js 파일은 없구요, 드롭다운 메뉴를 눌렀을 때 작동해야 되는데 작동이 안되네요..

코드 : 
```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bootstrap</title>
  <link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.min.css">
  
</head>
<body>
  <li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Dropdown
    </a>
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="#">Action</a>
      <a class="dropdown-item" href="#">Another action</a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item" href="#">Something else here</a>
    </div>
  </li>
  <script src="/node_modules/bootstrap/dist/js/bootstrap.bundle.js"></script>
</body>
</html>
```';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 2,
title = '최대 넓이일 때 넘쳐버리는 div를 맨 아래로 이동시키는 방법 좀 알려주세요',
`body` = '태그 7, 8이 아래로 내려가지 않고 넘치네요..
더 이상 사용할 수 있는 공간이 없을 때 어떻게 하면 밑으로 내릴 수 있는건가요?
```css
.main{
  width: 300px;
  height: 150px;
  display:flex;
  border: 2px solid #000;
  padding: 10px;
}

.inner{
  border: 1px solid #5eba7d;
  margin-right:5px;
  padding: 5px;
  height: max-content;
  width: max-content;
  white-space:nowrap;
}
```
```html
<div class="main">
 <div class="inner">tag 1</div>
 <div class="inner">tag 2</div>
 <div class="inner">tag 3</div>
 <div class="inner">tag 4</div>
 <div class="inner">tag 5</div>
 <div class="inner">tag 6</div>
 <div class="inner">tag 7</div>
 <div class="inner">tag 8</div>
</div>
```';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 2,
title = '반복 실행되는 함수를 어떻게 멈출 수 있나요?',
`body` = "우선 제 코드 입니다.
```javascript
$('#mybtn').click(function () {
    var canvas = document.getElementById('myCanvas');
    var ctx = canvas.getContext('2d', {willReadFrequently: true});
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    var interations = 0;

    function drawOnCanvas() {
        iterations++;
        //draw stuff on the canvas
        if (iterations < Number.MAX_SAFE_INTEGER - 1) {
            window.requestAnimationFrame(drawOnCanvas);
        }
    }
    drawOnCanvas();
});
```


유저가 mybtn 을 두번 눌렀을 때 캔버스가 다 지워지고 다시 캔버스에 그리는걸 기대하고 있었습니다.
그런데 이전 함수가 안멈추고 그대로 그려버리더라구요..
한번에 2개의 함수가 작동하는 상태에서 또 버튼을 누르면 3개의 함수가 동시에 실행됩니다 ㅠ

한 번에 하나씩, 중복없이 실행하는 방법이 있을까요?
해결방법 부탁드립니다!";

# 답변 테스트 데이터
INSERT INTO answer
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 4,
`body` = 'CDN으로 부트스트랩을 가져와야 합니다. 
그리고 `data-bs-toggle="dropdown"` 속성을 드롭다운 여는 버튼에 추가해주세요.

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bootstrap</title>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
  
</head>
<body>
  <li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Dropdown
    </a>
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="#">Action</a>
      <a class="dropdown-item" href="#">Another action</a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item" href="#">Something else here</a>
    </div>
  </li>
 <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js" integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V" crossorigin="anonymous"></script></script>
</body>
</html>
```',
choiceStatus = 1;

UPDATE article
SET memberId = 1,
title = 'QAFE 공지사항',
`body` = ''
WHERE id = 1;

#####################################################

SELECT * FROM reactionPoint;

SELECT * FROM article ORDER BY id DESC;

SELECT * FROM `member`;

SELECT * FROM board;

SELECT * FROM reply;

SELECT * FROM answer ORDER BY id DESC;

SELECT * FROM attr;

SELECT LAST_INSERT_ID();

/*
# 게시물 늘리기
insert into article
(
    regDate, updateDate, memberId, boardId, title, `body`
)
Select now(), Now(), FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 2) + 1, concat('제목_',rand()), CONCAT('내용_',RAND())
from article;
*/

/*
select A.* ,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
from (
    SELECT A.*, M.nickname AS writer
    FROM article AS A
    LEFT JOIN `member` AS M
    ON A.memberId = M.id
) as A
LEFT join reactionPoint AS RP
ON RP.relTypeCode = 'article'
and A.id = RP.relId
Group by A.id;
*/

/*
SELECT A.*, M.nickname as writer,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
FROM article AS A
LEFT JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON RP.relTypeCode = 'article'
and A.id = RP.relId
WHERE A.id = #{id}
*/

/*
select ifnull(SUM(RP.point),0) as s
from reactionPoint AS RP
WHERE RP.relTypeCode = 'article'
AND RP.relId = 2
AND RP.memberId = 2
*/

/*
select RP.relTypeCode, RP.relId,
SUM(IF(RP.point > 0, RP.point, 0)) as goodReactionPoint,
SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
from reactionPoint as RP
group by RP.relTypeCode, RP.relId
*/

