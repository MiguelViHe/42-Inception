# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mvidal-h <mvidal-h@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/14 11:25:13 by mvidal-h          #+#    #+#              #
#    Updated: 2025/10/22 16:14:09 by mvidal-h         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# penultimate stable version of debian
FROM debian:bullseye

RUN apt update -y

RUN apt install vsftpd -y

COPY ./tools/script.sh /
RUN chmod +x /script.sh

CMD ["/script.sh"]