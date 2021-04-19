package com.ding.lesson02;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SqlInjection {
    public static void main(String[] args) {
//        login("dingjiahao", "123456");
        // SELECT * FROM users WHERE `name`= '' or '1=1'  AND `password` = '' or '1=1';
        login("'or ' 1 = 1", "'or' 1=1");
    }

    // 登陆业务
    public static void login(String username, String password) {
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            conn = JdbcUtils.getConnection();
            st = conn.createStatement();


            String sql = "SELECT * FROM users WHERE `name`='" + username + "' AND `password`='" + password + "'" ;

            rs = st.executeQuery(sql);

            while(rs.next()) {
                System.out.println(rs.getString("name"));
                System.out.println(rs.getString("password"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, st, rs);
        }
    }
}
