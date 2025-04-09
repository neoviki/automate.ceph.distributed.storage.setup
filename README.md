## Ceph Distributed Storage System Setup

This script automates the installation and setup of the **Ceph Distributed Storage System** in your cluster. It configures the Ceph monitor, OSDs (Object Storage Daemons), MDS (Metadata Server), and RGW (Rados Gateway) on your specified cluster nodes. The script is designed to work with a specific setup and IP addresses, which you can customize based on your environment.

### Prerequisites

- Ubuntu or Debian-based system
- Sudo privileges on all nodes in the cluster
- Ceph repositories and packages installed
- Network connectivity between the nodes in the cluster

### Cluster Configuration

The script assumes the following host configuration:
- **Admin Node**: `host-192-168-0-6`
- **Ceph Monitor Node**: `host-192-168-0-20`
- **Ceph OSD Nodes**: 
  - `host-192-168-0-8`
  - `host-192-168-0-19`
  - `host-192-168-0-4`

You can modify the `USERNAME`, `CLUSTER_NAME`, and other variables as needed.

### How to Use

1. Clone or download the repository.
2. Customize the script with your host details:
   - Modify the hostnames for the monitor and OSD nodes.
   - Set the network range and cluster name.
3. Run the script:
   ```bash
   chmod +x ceph_setup.sh
   ./ceph_setup.sh
   ```

### Script Steps

1. **Initial Setup**: 
   - Downloads the Ceph repository keys.
   - Installs `ceph-deploy` and removes any conflicting older versions.
   
2. **Cluster Purge (Optional)**: 
   - Purges any previous Ceph deployments to avoid conflicts.

3. **Ceph Installation**:
   - Installs the necessary Ceph components (`ceph-mon`, `ceph-osd`, `ceph-mgr`, etc.) on the specified nodes.
   
4. **Ceph Configuration**:
   - Configures the public network and cluster settings.
   - Creates and initializes the monitor.
   
5. **OSD Creation**:
   - Configures and creates the OSDs on the specified nodes.

6. **MDS and RGW**:
   - Creates the Metadata Server and Rados Gateway.

7. **Monitor Addition**:
   - Adds additional monitor nodes as needed.

8. **Health Check**:
   - After installation, you can log into the monitor to check the health of the Ceph cluster.

