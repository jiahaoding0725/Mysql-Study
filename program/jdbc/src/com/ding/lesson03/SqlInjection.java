package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.*;

public class SqlInjection {
    public static void main(String[] args) {
        login("lisi", "123456");
        // SELECT * FROM users WHERE `name`= '' or '1=1'  AND `password` = '' or '1=1';
//        login("'or ' 1 = 1", "'or' 1=1");
    }

    // 登陆业务
    public static void login(String username, String password) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();
            // PreparedStatment 防止SQL注入的本质，把传递进来的参数当作字符
            // 假设其中存在转义字符，比如说 ' 会被直接转义
            String sql = "SELECT * FROM users WHERE `name`= ? AND `password`= ? ";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, username);
            pstm.setString(2, password);
            rs = pstm.executeQuery();

            while(rs.next()) {
                System.out.println(rs.getString("name"));
                System.out.println(rs.getString("password"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, rs);
        }
    }
}
