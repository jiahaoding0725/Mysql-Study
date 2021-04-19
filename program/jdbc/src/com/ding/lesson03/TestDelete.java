package com.ding.lesson03;

import com.ding.lesson02.util.JdbcUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

public class TestDelete {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstm = null;

        try {
            conn = JdbcUtils.getConnection();

            // 区别
            // 使用问号占位符代替参数
            String sql = "INSERT INTO users(id, `name`, `password`, email, birthday) VALUES(?,?,?,?,?)";
            pstm = conn.prepareStatement(sql); // 预编译SQL，先写SQL，然后不执行

            // 手动给参数赋值
            pstm.setInt(1, 4);
            pstm.setString(2, "dingjiahao");
            pstm.setString(3, "123456");
            pstm.setString(4, "dingjiahao@163.com");
            // new Date().getTime() 获得时间戳
            pstm.setDate(5, new java.sql.Date(new Date().getTime()));

            // 执行
            int i = pstm.executeUpdate();
            if (i > 0) {
                System.out.println("插入成功");
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            JdbcUtils.release(conn, pstm, null);
        }
    }
}
