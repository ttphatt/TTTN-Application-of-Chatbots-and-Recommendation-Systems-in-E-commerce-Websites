<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chat với Admin</title>
    <style>
        #chat-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #007bff;
            color: white;
            font-size: 24px;
            border: none;
            z-index: 1000;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        #chat-button #unread-count {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: red;
            color: white;
            border-radius: 50%;
            padding: 2px 5px;
            font-size: 14px;
            display: none;
        }

        #chat-box {
            display: none;
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 320px;
            height: 400px;
            background: white;
            border: 1px solid #ccc;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            padding: 10px;
            z-index: 1000;
            overflow: hidden;
            opacity: 0; /* Bắt đầu với độ mờ 0 */
            transition: opacity 0.3s ease-in-out; /* Hiệu ứng chuyển đổi mờ */
        }

        #messages {
            height: 320px;
            overflow-y: auto;
        }

        .message {
            padding: 5px 10px;
            margin: 5px;
            border-radius: 10px;
            max-width: 80%;
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
    </style>
</head>
<body>

<button id="chat-button" onclick="toggleChat()">
    💬
    <span id="unread-count">0</span>
</button>

<div id="chat-box">
    <div id="messages"></div>
    <input type="text" id="msgInput" placeholder="Nhập tin..." style="width: 80%;">
    <button onclick="sendMessage()">Gửi</button>
</div>

<script>
    const sender = "${loggedCustomer.id}"; // Gán ID người dùng
    const receiver = "admin"; // Gán ID người nhận
    const socket = new WebSocket("ws://localhost:9999/StoreWebsite/chat/" + sender);

    let unreadCount = 0;

    // Hàm toggle chat: mở/đóng khung chat
    function toggleChat() {
        const chatBox = document.getElementById("chat-box");
        if (chatBox.style.display === "none" || chatBox.style.display === "") {
            // Mở khung chat
            chatBox.style.display = "block";
            setTimeout(() => { chatBox.style.opacity = 1; }, 10);  // Fade in (khi mở)

            // Lấy lịch sử chat khi mở
            fetch("/StoreWebsite/loadChat?user1=" + sender + "&user2=" + receiver)
                .then(res => res.json())
                .then(data => {
                    document.getElementById("messages").innerHTML = ""; // Xóa tin nhắn cũ
                    data.forEach(msg => {
                        displayMessage(msg);
                    });
                });

            // Reset số tin nhắn chưa đọc khi mở chat
            unreadCount = 0;
            updateUnreadCount();
        } else {
            // Tắt khung chat
            chatBox.style.opacity = 0;
            setTimeout(() => { chatBox.style.display = "none"; }, 300);  // Fade out (khi đóng)
        }
    }

    // Nhận tin nhắn qua WebSocket
    socket.onmessage = function (event) {
        const msg = JSON.parse(event.data);
        // Chỉ hiển thị nếu tin nhắn thuộc về cặp đang chat
        if ((msg.sender === sender && msg.receiver === receiver) ||
            (msg.sender === receiver && msg.receiver === sender)) {
            displayMessage(msg);

            // Nếu khung chat đang đóng, tăng số lượng tin nhắn chưa đọc
            if (document.getElementById("chat-box").style.display === "none") {
                unreadCount++;
                updateUnreadCount();
            }
        }
    };

    // Cập nhật số lượng tin nhắn chưa đọc trên nút chat
    function updateUnreadCount() {
        const unreadCountElement = document.getElementById("unread-count");
        unreadCountElement.innerText = unreadCount;
        unreadCountElement.style.display = unreadCount > 0 ? "inline-block" : "none";
    }

    // Gửi tin nhắn qua WebSocket
    function sendMessage() {
        const input = document.getElementById("msgInput");
        const content = input.value.trim();
        if (!content) return;
        const msg = { sender, receiver, content };
        socket.send(JSON.stringify(msg));
        input.value = "";  // Xóa input sau khi gửi
    }

    // Hiển thị tin nhắn trong khung chat
    function displayMessage(msg) {
        const div = document.createElement("div");
        div.className = "message " + (msg.sender === sender ? "own" : "other");
        div.innerText = msg.content;
        document.getElementById("messages").appendChild(div);
        document.getElementById("messages").scrollTop = document.getElementById("messages").scrollHeight;
    }

    // Ngăn việc xuống dòng khi nhấn Enter trong input
    document.getElementById("msgInput").addEventListener("keydown", function(event) {
        if (event.key === "Enter") {
            event.preventDefault(); // Ngăn việc xuống dòng
            sendMessage();
        }
    });
</script>

</body>
</html>
