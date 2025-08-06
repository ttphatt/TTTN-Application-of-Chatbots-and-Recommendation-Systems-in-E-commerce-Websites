<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = "admin";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Chat</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container_2 {
            display: flex;
            flex: 1;
            height: 100%;
        }

        .sidebar {
            width: 25%;
            background-color: #f9f9f9;
            border-right: 1px solid #ccc;
            overflow-y: auto;
        }

        .chatbox {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            padding: 20px;
            box-sizing: border-box;
            background-color: #fefefe;
        }

        .user {
            padding: 15px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
            position: relative;
        }

        .user:hover {
            background-color: #e6e6e6;
        }

        .user.active {
            background-color: #d0e6f6;
        }

        .unread-count {
            position: absolute;
            top: 5px;
            right: 10px;
            background-color: red;
            color: white;
            border-radius: 50%;
            padding: 3px 6px;
            font-size: 12px;
            display: inline-block;
        }

        #chatWith {
            margin-bottom: 10px;
        }

        #messages {
            flex-grow: 1;
            overflow-y: auto;
            border: 1px solid #ccc;
            background-color: #fff;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
        }

        .message {
            padding: 8px 12px;
            margin: 6px 0;
            border-radius: 10px;
            max-width: 70%;
            word-wrap: break-word;
            clear: both;
        }

        .own {
            background-color: #dcf8c6;
            float: right;
            text-align: right;
        }

        .other {
            background-color: #f1f0f0;
            float: left;
            text-align: left;
        }

        #msgInput {
            width: 75%;
            padding: 8px;
        }

        button {
            padding: 8px 12px;
            margin-left: 10px;
        }

        .input-area {
            display: flex;
        }
    </style>
</head>
<body>
<jsp:include page="pageLoad.jsp"/>
<div class="container_2">
    <div class="sidebar" id="userList">
        <!-- Danh sách người dùng sẽ load vào đây -->
    </div>

    <div class="chatbox">
        <h3 id="chatWith">Chọn khách hàng để bắt đầu trò chuyện</h3>
        <div id="messages"></div>
        <div class="input-area">
            <input type="text" id="msgInput" placeholder="Nhập tin nhắn...">
            <button onclick="sendMessage()">Gửi</button>
        </div>
    </div>
</div>

<script>
    const sender = "admin";
    let receiver = null;
    let receiverDisplayName = null;
    const socket = new WebSocket("ws://localhost:9999/StoreWebsite/chat/" + sender);

    let unreadMessages = {}; // Lưu số lượng tin nhắn chưa đọc cho mỗi người

    socket.onmessage = function (event) {
        const msg = JSON.parse(event.data);
        if ((msg.sender === sender && msg.receiver === receiver) ||
            (msg.sender === receiver && msg.receiver === sender)) {
            displayMessage(msg);
        } else {
            // Nếu tin nhắn không phải của cuộc trò chuyện đang mở, tăng số lượng tin nhắn chưa đọc
            if (msg.sender !== sender) {
                unreadMessages[msg.sender] = (unreadMessages[msg.sender] || 0) + 1;
                updateUnreadCount(msg.sender);
            }
        }
    };

    function loadUsers() {
        fetch("/StoreWebsite/admin/chooseChat")
            .then(res => res.json())
            .then(users => {
                const userList = document.getElementById("userList");
                userList.innerHTML = "";
                users.forEach(u => {
                    const div = document.createElement("div");
                    div.className = "user";
                    div.innerText = u.id + " - " + u.firstname + " " + u.lastname;
                    div.dataset.userid = u.id; // lưu ID người dùng
                    div.onclick = () => openChatWith(u, div);

                    // Hiển thị số tin nhắn chưa đọc nếu có
                    const unreadCount = unreadMessages[u.id] || 0;
                    const unreadSpan = document.createElement("span");
                    unreadSpan.className = "unread-count";
                    unreadSpan.innerText = unreadCount > 0 ? unreadCount : "";
                    div.appendChild(unreadSpan);

                    userList.appendChild(div);
                });
            });
    }

    function openChatWith(user, clickedDiv) {
        receiver = String(user.id);
        receiverDisplayName = user.id + " - " + user.firstname + " " + user.lastname;
        document.getElementById("chatWith").innerText = "Đang chat với: " + receiverDisplayName;
        document.getElementById("messages").innerHTML = "";

        // Reset số tin nhắn chưa đọc khi mở cuộc trò chuyện
        unreadMessages[receiver] = 0;
        updateUnreadCount(receiver);

        // Highlight user đang chọn
        const userDivs = document.querySelectorAll(".user");
        userDivs.forEach(div => div.classList.remove("active"));
        clickedDiv.classList.add("active");

        fetch("/StoreWebsite/loadChat?user1=" + sender + "&user2=" + receiver)
            .then(res => res.json())
            .then(data => {
                document.getElementById("messages").innerHTML = "";
                data.forEach(msg => {
                    displayMessage(msg);
                });
            });
    }

    function sendMessage() {
        const input = document.getElementById("msgInput");
        const content = input.value.trim();
        if (!receiver || !content) return;

        const msg = { sender, receiver, content };
        socket.send(JSON.stringify(msg));
        input.value = "";
    }

    function displayMessage(msg) {
        const div = document.createElement("div");
        div.className = "message " + (msg.sender === sender ? "own" : "other");
        div.innerText = msg.content;
        document.getElementById("messages").appendChild(div);
        document.getElementById("messages").scrollTop = document.getElementById("messages").scrollHeight;
    }

    function updateUnreadCount(userId) {
        var s = '[data-userid="' + userId + '"]';
        const userDiv = document.querySelector(s);
        if (userDiv) {
            const unreadCountElement = userDiv.querySelector(".unread-count");
            if (unreadCountElement) {
                unreadCountElement.innerText = unreadMessages[userId] > 0 ? unreadMessages[userId] : "";
            }
        }
    }

    document.getElementById("msgInput").addEventListener("keydown", function(event) {
        if (event.key === "Enter") {
            event.preventDefault(); // Ngăn việc xuống dòng
            sendMessage();
        }
    });

    // Tải danh sách người dùng ngay khi trang load
    loadUsers();
</script>

<script>
    window.addEventListener("load", () => {
        const loader = document.querySelector(".loader_wrapper");

        setTimeout(() => {
            loader.classList.add("loader-hidden");

            loader.addEventListener("transitionend", () => {
                document.body.removeChild(loader);
            });
        }, 500);
    });
</script>

</body>
</html>
