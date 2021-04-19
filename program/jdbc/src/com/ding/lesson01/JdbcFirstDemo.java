package com.ding.lesson01;

import com.mysql.cj.jdbc.Driver;

import java.sql.*;

public class JdbcFirstDemo {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 1. 加载驱动
        // DriverManager.registerDriver(new Driver());
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 2. 用户信息和url
        // "协议://主机地址:端口号/数据库名?参数&参数&参数&参数"
        // oracle -- 1521
        // jdbc:oracl:thin:@localhost:151:sid
        String url = "jdbc:mysql://localhost:3306/jdbcstudy?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "Djh1023921169?";

        // 3. 连接成功，数据库对象
        Connection connection = DriverManager.getConnection(url, username, password);

        /*
        connection.rollback();
        connection.commit();
        connection.setAutoCommit(false);
        */

        // 4. 执行SQL的对象
        Statement statement = connection.createStatement();

        /*
        statement.executeQuery(); // 查询操作
        statement.execute(); // 执行任何SQL
        statement.executeUpdate(); // 更新，插入，删除。返回受影响行数
        */

        // 5. 执行SQL的对象去执行SQL
        String sql = "SELECT * FROM users";
        ResultSet resultSet = statement.executeQuery(sql);

        /*
        resultSet.getObject();
        resultSet.getString();
        resultSet.getInt();
        resultSet.getFloat();
        resultSet.getDouble();
        */


        /*
        resultSet.beforeFirst(); // 移动到最前面
        resultSet.afterLast(); // 移动到最后面
        resultSet.next(); // 移动到下一个数据
        resultSet.previous(); 移动到前一个数据
        resultSet.absolute(100); // 移动到指定行
        */

        while (resultSet.next()) {
            System.out.println("id=" + resultSet.getObject("id"));
            System.out.println("name=" + resultSet.getObject("NAME"));
            System.out.println("pwd=" + resultSet.getObject("PASSWORD"));
            System.out.println("email=" + resultSet.getObject("email"));
            System.out.println("birth=" + resultSet.getObject("birthday"));
        }



        // 6. 释放连接
        resultSet.close();
        statement.close();
        connection.close();
    }
}
