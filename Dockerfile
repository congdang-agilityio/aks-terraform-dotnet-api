# Build
FROM mcr.microsoft.com/dotnet/sdk:5.0 As build
WORKDIR /application
COPY BookStoreAPI/*.csproj .
RUN dotnet restore
COPY BookStoreAPI .
# COPY BookStore.Data/*.csproj ./BookStore.Data
COPY BookStore.Data/ ./../BookStore.Data
RUN dotnet publish -c Release -o publish

# Run
FROM mcr.microsoft.com/dotnet/sdk:5.0
WORKDIR /application
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
COPY --from=build /application/publish .
ENTRYPOINT [ "dotnet", "BookStoreAPI.dll" ]