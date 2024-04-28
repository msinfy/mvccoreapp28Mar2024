#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
RUN pwd
RUN ls -lrt
#COPY ["mvc_core_app.csproj", "mvc_core_app/"]
COPY .  mvc_core_app/

RUN dotnet restore "mvc_core_app/mvc_core_app.csproj"
RUN pwd
COPY . .
WORKDIR "/src/mvc_core_app"
RUN dotnet build "mvc_core_app.csproj" -c Release -o /app/build

#RUN dotnet build "mvc_core_app.csproj" -c Release -o /app/build --verbosity normal


FROM build AS publish
RUN dotnet publish "mvc_core_app.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mvc_core_app.dll"]