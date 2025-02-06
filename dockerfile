FROM mcr.microsoft.com/powershell:latest
ENV PSGALLERY_PROFILE_NAME="" \
    INFLUX_BUCKET="" \
    INFLUX_HOST="" \
    INFLUX_ORG="" \
    INFLUX_TOKEN=""
COPY ./scripts/ /scripts/
RUN chmod +x /scripts/env_setup.sh && \
    chmod +x /scripts/entrypoint.sh && \
    chmod +x /scripts/Get-ModuleDownloads.ps1 && \
    # Install cron
    apt-get update && \
    apt-get -y install cron && \ 
    pwsh -c "Install-Module PowerHTML -Force" && \
    # Add cron job
    echo "*/5 * * * * root /bin/bash -c 'source /scripts/env_setup.sh && pwsh /scripts/Get-ModuleDownloads.ps1' >> /proc/1/fd/1 2>&1" > /etc/cron.d/Get-ModuleDownloads
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
