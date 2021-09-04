# dockerfile
FROM node as BUILD

# MAINTAINER: 维护者信息
MAINTAINER Min "hsp_email@163.com"
#  WORKDIR：工作目录，类似于cd命令
WORKDIR  /app 
COPY . /app/
# VOLUME：用于指定持久化目录
VOLUME ./node_modules /app/node_modules
# RUN：构建镜像时执行的命令
RUN yarn && yarn build

# FROM：指定基础镜像，必须为第一个命令 使用 nginx最新版本作为基础镜像
FROM nginx

# 将当前文件夹的dist文件复制到容器的/usr/share/nginx/html目录
COPY --from=BUILD /app/dist /app
COPY --from=BUILD /app/nginx/nginx.conf /etc/nginx/nginx.conf
# COPY ./dist /usr/share/nginx/html/


# EXPOSE：指定于外界交互的端口 声明运行时容器暴露的端口（容器提供的服务端口）
EXPOSE 9000

# CMD:指定容器启动时要运行的命令
# CMD ["nginx", "-g"]

RUN echo 'echo init ok!!'
############  111111 ##################


# ARG：用于指定传递给构建运行时的变量
# 格式：
ARG <name>[=<default value>]
# 示例：
ARG site
ARG build_user=www


# ENV：设置环境变量
# 格式：
ENV <key> <value>  #<key>之后的所有内容均会被视为其<value>的组成部分，因此，一次只能设置一个变量
ENV <key>=<value>   #可以设置多个变量，每个变量为一个"<key>=<value>"的键值对，如果<key>中包含空格，可以使用\来进行转义，也可以通过""来进行标示；另外，反斜线也可以用于续行
# 示例：
ENV myName John Doe
ENV myDog Rex The Dog
ENV myCat=fluffy

# ENTRYPOINT：配置容器，使其可执行化。配合CMD可省去"application"，只使用参数。
# 格式：
ENTRYPOINT ["executable", "param1", "param2"] (可执行文件, 优先)
ENTRYPOINT command param1 param2 (shell内部命令)
# 示例：
FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]注：　　　ENTRYPOINT与CMD非常类似，不同的是通过docker run执行的命令不会覆盖ENTRYPOINT，而docker run命令中指定的任何参数，都会被当做参数再次传递给ENTRYPOINT。Dockerfile中只允许有一个ENTRYPOINT命令，多指定时会覆盖前面的设置，而只执行最后的ENTRYPOINT指令。




############  简约部署 ##################
# https://www.jianshu.com/p/ab76ba86eafc

FROM node
WORKDIR /app
COPY . /app
RUN npm install
EXPOSE 8888
CMD npm start   
 ## 如果想运行多条指令可以这样：
## CMD git pull && npm install && npm start

#################################
FROM node as BUILD
MAINTAINER Min "hsp_email@163.com"
WORKDIR  /app
COPY . /app/
VOLUME ./node_modules /app/node_modules
RUN yarn && yarn build

# 使用 nginx最新版本作为基础镜像
FROM nginx
COPY --from=BUILD /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=BUILD /app/dist /app

# 声明运行时容器暴露的端口（容器提供的服务端口）
EXPOSE 9000

RUN echo 'echo init ok!!'